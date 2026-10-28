#!/usr/bin/env node
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const repository = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const lock = JSON.parse(fs.readFileSync(process.env.DOTFILES_SKILLS_LOCK || path.join(repository, 'skills.lock.json'), 'utf8'));
const checkout = path.join(os.homedir(), '.local/share/kornicameister/skills');
function run(command, arguments_, options = {}) {
  const result = spawnSync(command, arguments_, { stdio: 'inherit', ...options });
  if (result.error || result.status !== 0) throw new Error(`${command} failed: ${result.error || result.status}`);
}
try {
  if (!/^[a-f0-9]{40}$/.test(lock.commit)) throw new Error('Skills commit must be a complete SHA');
  for (const command of ['git', 'npm', 'uv']) run(command, ['--version']);
  if (process.argv.includes('--dry-run')) {
    console.log(`Would install ${lock.repository} at ${lock.commit}`);
    process.exit(0);
  }
  if (!fs.existsSync(checkout)) {
    fs.mkdirSync(path.dirname(checkout), { recursive: true });
    const temporary = fs.mkdtempSync(`${checkout}-clone-`);
    try {
      run('git', ['-c', 'core.hooksPath=/dev/null', 'clone', '--no-checkout', lock.repository, temporary]);
      run('git', ['-C', temporary, '-c', 'core.hooksPath=/dev/null', 'checkout', '--detach', lock.commit]);
      fs.renameSync(temporary, checkout);
    } finally {
      fs.rmSync(temporary, { recursive: true, force: true });
    }
  } else {
    const status = spawnSync('git', ['-C', checkout, 'status', '--porcelain'], { encoding: 'utf8' });
    if (status.status !== 0 || status.stdout.trim()) throw new Error(`Private checkout has local changes: ${checkout}`);
    const head = spawnSync('git', ['-C', checkout, 'rev-parse', 'HEAD'], { encoding: 'utf8' });
    if (head.stdout.trim() !== lock.commit) {
      run('git', ['-C', checkout, 'fetch', lock.repository, lock.commit]);
      run('git', ['-C', checkout, '-c', 'core.hooksPath=/dev/null', 'checkout', '--detach', lock.commit]);
    }
  }
  run(process.execPath, [path.join(checkout, 'install.mjs'), '--dotfiles', repository, ...process.argv.slice(2)]);
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}

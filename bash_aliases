
# upgrade all system packages of pip
alias pip_glob_upgrade="pip freeze | tr '=' ' ' | awk '{print $1}' | xargs sudo -EH pip install --upgrade"


# pip
alias pip_glob_upgrade="pip freeze | tr '=' ' ' | awk '{print $1}' | xargs sudo -EH pip install --upgrade"
alias pip_install_os="pip install -r requirements.txt -r test-requirements.txt -c https://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?master"
alias pip_upgrade_os="pip_install_os --upgrade"

# time vagrant run
alias vagrant="time vagrant"
alias vagrant_up="vagrant destroy -f && rm -rf .vagrant && vagrant up"
alias vagrant_destroy="vagrant destroy -f && rm -rf .vagrant"


#-------------------------------------------------------------------------------

# Copyright 2017 Actian Corporation

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#-------------------------------------------------------------------------------
#
# This chef script will install a previously downloaded community edition of
# Actian Vector as installation VH in /opt/Actian/Vector.
#
# The following files are required by this script and should have previously
# been downloaded from Actian into the folder from which Vagrant was launched:
#    1. Vector Community Installation download. This ships in the native package
#       manager (ingbuild) format:
#         e.g. actian-vector-4.2.1-190-community-linux-x86_64.tgz
#
#-------------------------------------------------------------------------------


# Get the specific version and path we are using into a variable for location used

vector_package_with_path = `ls -t /tmp/actian-vector*.tgz 2> /dev/null | head -1 | tr -d "\n"`
vector_installation = `ls -t /tmp/actian-vector*.tgz | head -1 | tr -d "\n" | sed "s@/tmp/@@g" | sed "s/.tgz//"`
vector_install_loc  = "/home/actian/installer/"

installer  = ::File.join( vector_install_loc, vector_installation, "/install.sh" )

# Untar the Vector installation package

execute "tar -xzf /tmp/actian-vector*.tgz" do
  cwd "#{vector_install_loc}"
  not_if { File.exist?("#{installer}") }
end

# Install Vector

bash 'run installer' do
  code <<-EOH
    #{installer} -express -acceptlicense /opt/actian/vector VW > /tmp/vector_install.log 2>&1
    echo Please find and review the installation log file in /tmp/vector_install.log if needed.
  EOH
  not_if { File.exist?("/opt/Actian/Vector/ingres/files/errlog.log") }
end

#-------------------------------------------------------------------------------
# End of Chef ruby script
#-------------------------------------------------------------------------------

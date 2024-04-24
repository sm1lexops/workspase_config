# Implementing a Web Application Firewall (WAF) with ModSecurity in Nginx involves installing and configuring ModSecurity, a widely used open-source WAF module, along with the Nginx web server. Below are the steps to implement WAF with ModSecurity in Nginx:

1. **Install ModSecurity**:
   - Install ModSecurity and its dependencies. You can typically install ModSecurity using package managers like `apt` for Debian-based systems or `yum` for Red Hat-based systems.

2. **Compile Nginx with ModSecurity Support**:
   - If you're using a package manager, you may need to install the Nginx ModSecurity module separately. Alternatively, you can compile Nginx from source with ModSecurity support.

3. **Configure ModSecurity**:
   - Create a ModSecurity configuration file (`modsecurity.conf`) and define rules to protect your web applications. You can use default rule sets like OWASP ModSecurity Core Rule Set (CRS) or create custom rules based on your application's requirements.

4. **Integrate ModSecurity with Nginx**:
   - Include the ModSecurity module in your Nginx configuration file (`nginx.conf`) using the `LoadModule` directive.
   - Configure Nginx to load the ModSecurity configuration file and apply ModSecurity rules to incoming HTTP requests.
   - Example configuration snippet:
     ```nginx
     LoadModule security2_module modules/mod_security2.so;
     ModSecurityEnabled on;
     ModSecurityConfig /etc/nginx/modsecurity/modsecurity.conf;
     ```

5. **Test and Adjust Configuration**:
   - Test your Nginx configuration to ensure that ModSecurity is correctly integrated and functioning as expected.
   - Monitor ModSecurity logs for any detected threats or false positives and adjust rules accordingly.

6. **Optimize Performance**:
   - Fine-tune ModSecurity performance by optimizing rule sets, adjusting thresholds, and whitelisting known safe requests to minimize false positives.
   - Consider implementing caching mechanisms and other performance optimizations to minimize the impact of ModSecurity on Nginx performance.

7. **Regularly Update Rules**:
   - Keep ModSecurity rules up-to-date by regularly updating rule sets to address emerging threats and vulnerabilities.

8. **Monitor and Maintain**:
   - Monitor ModSecurity logs and Nginx access logs for any suspicious activity or security incidents.
   - Perform regular security audits and penetration testing to identify and address potential vulnerabilities in your web applications.

By following these steps, you can implement WAF with ModSecurity in Nginx to protect your web applications from common security threats and vulnerabilities. Adjust the configuration according to your specific requirements and application architecture.

```sh
# installing dependencies

sudo apt install nginx
sudo apt install -y apt-utils build-essential git wget libtool libpcre3-dev zlib1g-dev libssl-dev libxml2-dev libgeoip-dev liblmdb-dev libyajl-dev libcurl4-openssl-dev libpcre++-dev pkgconf libxslt1-dev libgd-dev automake
cd /usr/local/src
git clone --depth 100 -b v3/master --single-branch https://github.com/owasp-modsecurity/ModSecurity
chmod 755 -R ModSecurity/
cd ModSecurity
sudo git submodule init
sudo git submodule update
sudo ./build.sh
sudo ./configure
sudo make
sudo make install
mkdir /usr/local/src/cpg
cd /usr/local/src/cpg
# check your nginx -v (version)
export NGINX_VER=$(nginx -v 2>&1 | cut -d'/' -f2 | cut -d' ' -f1)
# add latest stable version owasp crs modsec
export MODSEC_VER=4.2.0
sudo wget http://nginx.org/download/nginx-$NGINX_VER.tar.gz
sudo tar -xvzf nginx-$NGINX_VER.tar.gz
# Download the source code for ModSecurity-nginx connector
sudo git clone https://github.com/SpiderLabs/ModSecurity-nginx
cd nginx-$NGINX_VER/
sudo ./configure --with-compat --with-openssl=/usr/include/openssl/ --add-dynamic-module=/usr/local/src/cpg/ModSecurity-nginx
sudo make modules
sudo cp objs/ngx_http_modsecurity_module.so /usr/share/nginx/modules/

## configure ModSecurity rules with OWASP CRS (Core Rule Set)
sudo mkdir /etc/nginx/modsec
cd /etc/nginx/modsec
sudo wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
sudo mv modsecurity.conf-recommended modsecurity.conf
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf
sudo cp /usr/local/src/ModSecurity/unicode.mapping /etc/nginx/modsec/
sudo cat <<EOF | sudo tee /etc/nginx/modsec/main.conf
# Include the recommended configuration
Include /etc/nginx/modsec/modsecurity.conf
# OWASP CRS v4 rules
Include /usr/local/coreruleset-$MODSEC_VER/crs-setup.conf
Include /usr/local/coreruleset-$MODSEC_VER/rules/*.conf
# A test rule
SecRule ARGS:testparam "@contains test" "id:1234,deny,log,status:403"
EOF

# Add next line to /etc/nginx/nginx.conf to http { block
server {
        modsecurity on;
        modsecurity_rules_file /etc/nginx/modsec/main.conf;
}

sudo wget https://github.com/coreruleset/coreruleset/archive/refs/tags/v$MODSEC_VER.tar.gz
sudo tar -xzvf v$MODSEC_VER.tar.gz
sudo mv coreruleset-$MODSEC_VER /usr/local
cd /usr/local/coreruleset-$MODSEC_VER
sudo cp crs-setup.conf.example crs-setup.conf


## configure cPGuard for WAF rules
Step 5: Install Nginx configuration
1. Open /etc/nginx/nginx.conf and add the following line after including “/etc/nginx/sites-enabled/*.conf”

include /etc/nginx/cpguard_waf_load.conf;
2. Add the following contents to /etc/nginx/cpguard_waf_load.conf

modsecurity on;
modsecurity_rules_file /etc/nginx/nginx-modsecurity.conf;
3. Add following contents to /etc/nginx/nginx-modsecurity.conf

SecRuleEngine On
SecRequestBodyAccess On
SecDefaultAction "phase:2,deny,log,status:406"
SecRequestBodyLimitAction ProcessPartial
SecResponseBodyLimitAction ProcessPartial
SecRequestBodyLimit 13107200
SecRequestBodyNoFilesLimit 131072
SecPcreMatchLimit 250000
SecPcreMatchLimitRecursion 250000
SecCollectionTimeout 600
SecDebugLog /var/log/nginx/modsec_debug.log
SecDebugLogLevel 0
SecAuditEngine RelevantOnly
SecAuditLog /var/log/nginx/modsec_audit.log
SecUploadDir /tmp
SecTmpDir /tmp
SecDataDir /tmp
SecTmpSaveUploadedFiles on
# Include file for cPGuard WAF
Include /etc/nginx/cpguard_waf.conf
Step 6: Configure cPGuard WAF Parameters
Once the above steps are completed successfully, you can use the following parameter values.

waf_server = nginx
waf_server_conf = /etc/nginx/cpguard_waf.conf
waf_server_restart_cmd = /usr/sbin/service nginx restart
waf_audit_log = /var/log/nginx/modsec_audit.log

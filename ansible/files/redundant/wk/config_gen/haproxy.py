
# Environment
WK_IP_1 = '192.168.11.121'
WK_IP_2 = '192.168.11.122'
WK_IP_3 = '192.168.11.123'

lists = {
    # id           # service                # IP               # port   # nodeport
    'service41': [ 'argocd',                '192.168.11.141',  '443',   '30041' ],
    'service42': [ 'grafana',               '192.168.11.142',  '80',    '30042' ],
    'service43': [ 'prometheus',            '192.168.11.143',  '9090',  '30043' ],
    'service44': [ 'minio',                 '192.168.11.144',  '80',    '30044' ],
    'service45': [ 'loki',                  '192.168.11.145',  '3100',  '30045' ],
    'service46': [ 'tempo',                 '192.168.11.146',  '4317',  '30046' ],
    'service47': [ 'pyroscope',             '192.168.11.147',  '4040',  '30047' ],
    'service48': [ 'n8n',                   '192.168.11.148',  '5678',  '30048' ],
    'service49': [ 'postgres-operator-ui',  '192.168.11.148',  '80',    '30049' ],
    'service49': [ 'k8s-sentry',            '192.168.11.148',  '80',    '30050' ],

    'service51': [ 'misskey-redis',         '192.168.11.151',  '26379', '30051' ],
    'service52': [ 'misskey-postgres',      '192.168.11.152',  '5432',  '30052' ],
    'service53': [ 'private-isu-memcached', '192.168.11.153',  '11211', '30053' ],
    'service54': [ 'private-isu-mysql',     '192.168.11.154',  '3306',  '30054' ],

    'service81': [ 'scrape',                '192.168.11.181',  '80',    '30081' ],
    'service82': [ 'private-isu',           '192.168.11.182',  '80',    '30082' ],
    'service83': [ 'misskey',               '192.168.11.183',  '443',   '30083' ],
}

# config gen haproxy
from jinja2 import Template

def generate_script(template_path, output_path, **kwargs):
    with open(template_path, 'r') as file:
        template_content = file.read()

    template = Template(template_content)

    rendered_script = template.render(**kwargs)

    with open(output_path, 'w') as output_file:
        output_file.write(rendered_script)

generate_script('../haproxy/template.cfg', '../haproxy/haproxy.cfg', lists=lists, WK_IP_1=WK_IP_1, WK_IP_2=WK_IP_2, WK_IP_3=WK_IP_3)

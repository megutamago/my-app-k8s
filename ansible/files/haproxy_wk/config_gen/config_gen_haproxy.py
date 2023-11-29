
# Environment
WK_IP_1 = '192.168.11.121'
WK_IP_2 = '192.168.11.122'
WK_IP_3 = '192.168.11.123'

lists = {
    # id          # service   # IP               # port    # nodeport
    'service1': [ 'argocd',   '192.168.11.140',  '443',    '31000'   ],
    'service2': [ 'grafana',  '192.168.11.141',  '80',     '31001'   ],
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

generate_script('../haproxy/template.cfg', '../haproxy/test.cfg', lists=lists, WK_IP_1=WK_IP_1, WK_IP_2=WK_IP_2, WK_IP_3=WK_IP_3)

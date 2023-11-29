
# Environment
WK_IP_1 = '192.168.11.121'
WK_IP_3 = '192.168.11.123'

lists = {
    # id          # LB_ID  # vrId  # IP             
    'service1': [ '1',     '61',   '192.168.11.140' ],
    'service2': [ '2',     '62',   '192.168.11.141' ],
    'service3': [ '3',     '63',   '192.168.11.142' ],
    'service4': [ '4',     '64',   '192.168.11.143' ],
    'service5': [ '5',     '65',   '192.168.11.144' ],
    'service6': [ '6',     '66',   '192.168.11.145' ],
}

# config gen keepalived
from jinja2 import Template

def generate_script(template_path, output_path, **kwargs):
    with open(template_path, 'r') as file:
        template_content = file.read()

    template = Template(template_content)

    rendered_script = template.render(**kwargs)

    with open(output_path, 'w') as output_file:
        output_file.write(rendered_script)

generate_script('../keepalived/template.conf', '../keepalived/keepalived.conf', lists=lists, WK_IP_1=WK_IP_1, WK_IP_3=WK_IP_3)

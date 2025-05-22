const post = (nui, data) => {
    $.post(
        "https://" + GetParentResourceName() + "/" + nui,
        JSON.stringify(data)
    );
}

window.addEventListener("message", (event) => {
    const data = event.data;
    if(data.type === "display") {
        ShowFlags(data.value);
    } else if(data.type === "init") {
        data.flags.forEach((e) => {
            CreateContainer(e.title, e.elements);
        })
    }
});

window.addEventListener('DOMContentLoaded', () => {
    post('ready', JSON.stringify({}));
})

window.addEventListener('mousemove', (e) => {
    let [x, y] = [(e.clientX / window.innerWidth), (e.clientY / window.innerHeight)];
    post('mouse_move', {x: x, y: y});
})

function ChangeStateOfHeader(e) {
    const arrow = e.parentNode.querySelector('i');
    arrow.classList.toggle('hidden-header');
    arrow.classList.toggle('visible-header');
    e.parentNode.parentNode.querySelector('.container-body').classList.toggle('container-hidden');
}

function CheckboxStateChanged(e) {
    post('set_flag', {flag: e.name, value : e.checked})
}

function ShowFlags(display) {
    document.querySelector("#flags_container").style.display = display ? 'block' : 'none';
}

function CreateContainer(title, elements) {
    const container = document.createElement('div');
    container.classList.add('container');
    
    const header = document.createElement('div');
    header.classList.add('container-header');
    
    const caretIcon = document.createElement('i');
    caretIcon.classList.add('fa-solid', 'fa-caret-down', 'visible-header');
    header.appendChild(caretIcon);
    
    const titleSpan = document.createElement('span');
    titleSpan.classList.add('container-header-title');
    titleSpan.textContent = title;
    titleSpan.onclick = function() {
        ChangeStateOfHeader(this);
    };
    header.appendChild(titleSpan);
    
    container.appendChild(header);
    
    const body = document.createElement('div');
    body.classList.add('container-body');
    
    elements.forEach((value) => {
        const containerElement = document.createElement('div');
        containerElement.classList.add('container-element');
        
        const textSpan = document.createElement('span');
        textSpan.textContent = value.name;
        containerElement.appendChild(textSpan);
        
        const checkbox = document.createElement('input');
        checkbox.setAttribute('type', 'checkbox');
        checkbox.setAttribute('name', value.name);
        checkbox.checked = value.value ? value.value : false;
        checkbox.oninput = function() {
            CheckboxStateChanged(this);
        };
        containerElement.appendChild(checkbox);
        
        body.appendChild(containerElement);
    })
    container.appendChild(body);
    document.querySelector('#flags_container').appendChild(container)
}
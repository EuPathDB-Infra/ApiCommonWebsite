/** Proof of concept for EuPathDB SPA in Globus **/

void function bootstrap(container) {
  workflows().then(function(ws) {
    render(dom(ws), container);
  })
}(container());

function render(element, rootNode) {
  for (var i = 0; i < rootNode.children.length; i++) {
    rootNode.removeChild(rootNode.children[i]);
  }
  rootNode.appendChild(element);
}

function container() {
  var container = document.getElementById('eupathdb-container');
  var center = document.getElementById('center');

  if (container == null) {
    container = element('div', { id: 'eupathdb-container'});
    center.insertBefore(container, center.children[0])
  }

  return container;
}

function workflows() {
  return jQuery.getJSON('/api/workflows');
}

function dom(workflows) {
  return element(
    'div',
    null,
    element('h1', null, text('Hello EuPathDB User')),
    element('p', null, text(workflows.length ? 'Here are your workflows:' : 'You don\'t have any workflows.')),
    workflows.length ? element('ol', null, workflows.map(function(w) {
      return element(
        'li', null,
        element('a', {
          href: '/workflow/display_by_id?id=' + w.id,
          target: '_parent'
        }, text(w.name))
      );
    })) : null
  );
}

function element(name, props /*, ...children */) {
  var children = _.flatten(_.rest(arguments, 2));
  var e = document.createElement(name);
  for (var i = 0; i < children.length; i++) {
    if (children[i] != null)
      e.appendChild(children[i]);
  }
  for (var propKey in props) {
    e[propKey] = props[propKey];
  }
  return e;
}

function text(str) {
  return document.createTextNode(str);
}

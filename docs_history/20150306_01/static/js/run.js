// 参考:
// https://app.codegrid.net/entry/web-components-3
// http://www.html5rocks.com/ja/tutorials/webcomponents/customelements/
// http://www.html5rocks.com/ja/tutorials/webcomponents/shadowdom/
(function () {
    "use strict";
    var examples = document.querySelectorAll(".codeExample");

    Array.prototype.forEach.call(examples, function (example, index) {
        var appendTarget = example.querySelector(".exampleOutput");
        var OutputExample = Object.create(HTMLElement.prototype);
        var OutputExampleElem;
        var outputExampleElem = document.createElement("x-sg-output-example-" + index);

        OutputExample.createdCallback = function () {
            var shadowRoot = this.createShadowRoot();
            var template = example.querySelector(".renderedExampleTmpl");

            shadowRoot.innerHTML = template.innerHTML;
        };

        OutputExampleElem = document.registerElement("x-sg-output-example-" + index, {
            prototype: OutputExample
        });
        appendTarget.appendChild(outputExampleElem);
    });
}());

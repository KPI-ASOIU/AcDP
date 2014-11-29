$('input[data-id="docSearch"]').on('keyup', function(event) {
    var searchDocForm = document.querySelector('#searchDocForm'),
        title = searchDocForm.querySelector('#title'),
        description = searchDocForm.querySelector('#description');
    // home $, end #
    if (/[a-zA-Z0-9-_.]/.test(String.fromCharCode(event.keyCode))) {
        $.ajax({
            type: "GET",
            url: searchDocForm.getAttribute('data-search-url'),
            data: {
                title: title.value,
                description: description.value
            },
            dataType: "json",
            success: function(data) {
                var results = document.querySelector("#docSearchResults");
                $(results).empty()
                for (var res in data) {
                    var item = document.createElement('div'),
                        content = document.createElement('div'),
                        name = document.createElement('div'),
                        title = document.createTextNode(data[res].text === null ? I18n.documents.no_title : data[res].text),
                        description = document.createElement('p'),
                        desc = document.createTextNode(data[res].description === null ? I18n.documents.no_description : data[res].description),
                        type = document.createElement('i');
                    selectLabel = document.createElement('a'),
                    selectIcon = document.createElement('i');

                    item.setAttribute('class', 'item');
                    content.setAttribute('class', 'content');
                    name.setAttribute('class', 'name');
                    name.appendChild(title);
                    description.setAttribute('class', 'description');
                    description.appendChild(desc);
                    type.setAttribute('class', data[res].type == 'folder' ? 'folder icon' : 'file icon');
                    content.appendChild(type);
                    content.appendChild(name);
                    content.appendChild(description);
                    selectLabel.setAttribute('class', 'ui blue corner label');
                    selectIcon.setAttribute('class', 'add icon');
                    selectLabel.appendChild(selectIcon);
                    item.appendChild(selectLabel);
                    item.appendChild(content);
                    results.appendChild(item);

                    selectLabel.addEventListener('click', function(e) {
                        var item = $(e.target).closest('div.item'),
                            label = item.find('.label'),
                            icon = label.find('.icon'),
                            itemBgColor = item.css('background-color') == "rgb(255, 255, 255)" ? "#6ecff5" : "#ffffff",
                            labelClass = (/red/.test(label.attr('class')) ? "blue" : "red") + " ui corner label",
                            iconClass = (/add/.test(icon.attr('class')) ? "remove" : "add") + " icon";

                        item.css('background-color', itemBgColor);
                        label.attr('class', labelClass);
                        icon.attr('class', iconClass);
                    }, false);
                }
                $('#addDocModal').modal('refresh');
            },
            error: function() {
                alert("Error during search");
            }
        })
    }
});
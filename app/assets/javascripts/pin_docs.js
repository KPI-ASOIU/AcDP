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
                        type = document.createElement('i'),
                        selectLabel = document.createElement('a'),
                        selectIcon = document.createElement('i'),
                        select = function(e) {
                            var item = $(e.target).closest('div.item'),
                                label = item.find('.label'),
                                icon = label.find('.icon'),
                                itemBgColor = item.css('background-color') == "rgb(255, 255, 255)" ? "#6ecff5" : "#ffffff",
                                labelClass = (/red/.test(label.attr('class')) ? "blue" : "red") + " ui corner label",
                                iconClass = (/add/.test(icon.attr('class')) ? "remove" : "add") + " icon",
                                isPinned = item.attr('data-pinned') == "false" ? true : false;
                            e.stopPropagation();
                            item.css('background-color', itemBgColor);
                            item.attr('data-pinned', isPinned)
                            label.attr('class', labelClass);
                            icon.attr('class', iconClass);
                        };

                    item.setAttribute('class', 'item');
                    item.setAttribute('data-pinned', false)
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

                    item.addEventListener('click', select, false);
                    selectLabel.addEventListener('click', select, false);
                }
                $('#addDocModal').modal('refresh');
            },
            error: function() {
                alert("Error during search");
            }
        })
    }
});

$('button#pinDocs').on('click', function(event) {
    event.preventDefault();
    var pinnedDocs = $('#docSearchResults div[data-pinned="true"]'),
        titles = $.map(pinnedDocs.find('div.name'), function(doc) {
            return doc.innerHTML;
        }),
        placeToPin = $('#pinnedDocs');
    $('#addDocModal').modal('hide');
    $('#addDocModal').modal('hide dimmer');
    $('#docUploadChoice').modal('hide');
    $('#docUploadChoice').modal('hide dimmer');
    console.log(titles)
    for (var cur in titles) {
        var label = document.createElement('div'),
            removeIcon = document.createElement('i');
        label.setAttribute('class', 'ui label');
        removeIcon.setAttribute('class', 'delete icon');
        label.appendChild(document.createTextNode(titles[cur]));
        label.appendChild(removeIcon);

        removeIcon.addEventListener('click', function(e) {
            $(e.target).closest('.ui.label').remove();
        }, false)
        placeToPin.append(label);
    }
    placeToPin.append()
});
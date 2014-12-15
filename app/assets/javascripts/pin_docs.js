var hideModals = function() {
        $('#addDocModal').modal('hide');
        $('#addDocModal').modal('hide dimmer');
        $('#docUploadChoice').modal('hide');
        $('#docUploadChoice').modal('hide dimmer');
    },
    detachDoc = function(e) {
        e.preventDefault();
        console.log(e.target)
        var item = $(e.target).closest('.ui.item'),
            id = item.attr('data-id'),
            detachDocUrl = $("#pinnedDocsExt").attr('data-detach-doc-url').replace('0', id);
        $.ajax({
            type: "POST",
            url: detachDocUrl,
            dataType: "json",
            success: function() {
                item.remove();
            },
            error: function() {
                alert("Server error! Document is not detached.")
            }
        })
    },
    hideDoc = function(e) {
        $(e.target).closest('.ui.item').remove();
    };

$('#attachDocument').on('click', function(e) {
    e.preventDefault();
    $('#docUploadChoice').modal('show');
});

$('#pinDocFromWarehouse').on('click', function(e) {
    e.preventDefault();
    $('#docSearchResults').empty()
    $('#searchDocForm #title').val(null)
    $('#searchDocForm #description').val(null)
    $('#addDocModal').modal('show');
    $('#addDocModal').modal('refresh');
});

$('#pinDocFromPC').on('click', function(e) {
    e.preventDefault();
    $('#docFromPCInput').trigger('click');
});

$(document).on('click', '[data-document="attached"] > i.delete', function(e) {
    $(e.target).closest('.ui.label').remove();
})

$(document).on('change', '#docFromPCInput', function(e) {
    e.preventDefault();
    var placeToPin = $('#pinnedDocs'),
        control = e.target,
        title = document.querySelector('#taskDoc #title'),
        description = document.querySelector('#taskDoc #description'),
        today = new Date(),
        descText = 'Added ' + today.getDate() + '.' + today.getMonth() + '.' + today.getFullYear(),
        form = $('#taskDoc');
    title.value = control.files[0].name;
    title.setAttribute('data-value', control.files[0].name)
    description.setAttribute('data-value', descText);
    form.submit();
    if (placeToPin.length > 0) {
        var label = document.createElement('div'),
            removeIcon = document.createElement('i');
        label.setAttribute('class', 'ui label');
        removeIcon.setAttribute('class', 'delete icon');
        label.appendChild(document.createTextNode(title.value));
        label.appendChild(removeIcon);
        removeIcon.addEventListener('click', function(e) {
            $(e.target).closest('.ui.label').remove();
        }, false)
        placeToPin.append(label);
    } else {
        placeToPin = $('#pinnedDocsExt')
        $.ajax({
            type: "GET",
            url: form.attr('data-url'),
            data: {
                'file_name': control.files[0].name,
                'file_size': control.files[0].size
            },
            dataType: "json",
            success: function(data) {
                var item = document.createElement('div'),
                    label = document.createElement('div'),
                    iconAction = document.createElement('i'),
                    iconRemove = document.createElement('i'),
                    content = document.createElement('div'),
                    name = document.createElement('div'),
                    desc = document.createElement('p'),
                    confirmLabel = document.createElement('div');
                item.setAttribute('class', 'ui item extended-doc');
                item.setAttribute('data-document', 'attached');
                item.setAttribute('data-id', data.doc_id);
                label.setAttribute('class', 'ui top right attached label');
                confirmLabel.setAttribute('id', 'confirm');
                confirmLabel.setAttribute('class', 'ui bottom attached green label');
                confirmLabel.appendChild(document.createTextNode(I18n.util.confirm))
                iconAction.setAttribute('class', 'download disk icon');
                iconRemove.setAttribute('class', 'delete icon')
                iconRemove.setAttribute('data-aim', 'detach');
                content.setAttribute('class', 'content');
                name.setAttribute('class', 'name');
                name.appendChild(document.createTextNode(control.files[0].name));
                desc.setAttribute('class', 'description');
                desc.appendChild(document.createTextNode(descText));
                label.appendChild(iconAction);
                label.appendChild(iconRemove);
                item.appendChild(label);
                content.appendChild(name);
                content.appendChild(desc);
                item.appendChild(content);
                item.appendChild(confirmLabel);

                iconRemove.addEventListener('click', hideDoc, false)
                confirmLabel.addEventListener('click', function(e) {
                    e.preventDefault();
                    var item = $(e.target).closest('.ui.item'),
                        id = item.attr('data-id'),
                        attachDocUrl = $("#pinnedDocsExt").attr('data-attach-doc-url').replace('0', id);
                    $.ajax({
                        type: "POST",
                        url: attachDocUrl,
                        dataType: "json",
                        success: function(data) {
                            if (data.status == 200) {
                                item.find('#confirm').remove();
                                var iconRemove = item.find('[data-aim="detach"]')[0];
                                iconRemove.removeEventListener('click', hideDoc);
                                iconRemove.addEventListener('click', detachDoc, false);
                            } else if (data.status == 204) {
                                alert("Document already pinned");
                                item.remove();
                            }
                        },
                        error: function() {
                            alert("Server error! Document is not attached.")
                        }
                    })
                }, false)
                placeToPin.append(item);
            }
        })
    }
    hideModals();
})

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
                    item.setAttribute('data-pinned', false);
                    item.setAttribute('data-id', data[res]['id'])
                    content.setAttribute('class', 'content');
                    name.setAttribute('class', 'name');
                    name.setAttribute('data-attr', 'name')
                    name.appendChild(title);
                    description.setAttribute('class', 'description');
                    description.setAttribute('data-attr', 'desc');
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
    var pinnedDocs = $('#docSearchResults div[data-pinned="true"]').get(),
        placeToPin = $('#pinnedDocs'),
        noPinnedDocsStub = $('#noPinnedDocs');
    hideModals();
    if (noPinnedDocsStub.length != 0)
        noPinnedDocsStub.fadeOut();
    for (var cur in pinnedDocs) {
        var label = document.createElement('div'),
            icon = document.createElement('i'),
            input = document.createElement('input');
        label.setAttribute('class', 'ui label');
        icon.setAttribute('class', 'delete icon');
        input.setAttribute('name', 'documents[]');
        input.setAttribute('type', 'hidden');
        input.setAttribute('value', pinnedDocs[cur].getAttribute('data-id'));
        label.appendChild(input);
        label.appendChild(document.createTextNode($(pinnedDocs[cur]).find('div[data-attr="name"]').html()));
        label.appendChild(icon);

        icon.addEventListener('click', function(e) {
            $(e.target).closest('.ui.label').remove();
        }, false)
        placeToPin.append(label);
    }
    placeToPin.append()
});

$('[data-aim="detach"]').on('click', detachDoc)

$('button#pinDocsExt').on('click', function(event) {
    event.preventDefault();
    var pinnedDocs = $('#docSearchResults div[data-pinned="true"]').get(),
        placeToPin = $('#pinnedDocsExt'),
        noPinnedDocsStub = $('#noPinnedDocs');
    hideModals();
    if (noPinnedDocsStub.length != 0)
        noPinnedDocsStub.fadeOut();
    for (var cur in pinnedDocs) {
        var item = document.createElement('div'),
            label = document.createElement('div'),
            iconAction = document.createElement('i'),
            iconRemove = document.createElement('i'),
            content = document.createElement('div'),
            name = document.createElement('div'),
            desc = document.createElement('p'),
            confirmLabel = document.createElement('div'),
            jqDoc = $(pinnedDocs[cur]);
        item.setAttribute('class', 'ui item extended-doc');
        item.setAttribute('data-document', 'attached');
        item.setAttribute('data-id', pinnedDocs[cur].getAttribute('data-id'));
        label.setAttribute('class', 'ui top right attached label');
        confirmLabel.setAttribute('id', 'confirm');
        confirmLabel.setAttribute('class', 'ui bottom attached green label');
        confirmLabel.appendChild(document.createTextNode(I18n.util.confirm))
        iconAction.setAttribute('class', 'download disk icon');
        iconRemove.setAttribute('class', 'delete icon')
        iconRemove.setAttribute('data-aim', 'detach');
        content.setAttribute('class', 'content');
        name.setAttribute('class', 'name');
        name.appendChild(document.createTextNode(jqDoc.find('div[data-attr="name"]').html()));
        desc.setAttribute('class', 'description');
        desc.appendChild(document.createTextNode(jqDoc.find('p[data-attr="desc"]').html()));
        label.appendChild(iconAction);
        label.appendChild(iconRemove);
        item.appendChild(label);
        content.appendChild(name);
        content.appendChild(desc);
        item.appendChild(content);
        item.appendChild(confirmLabel);

        iconRemove.addEventListener('click', hideDoc, false)
        confirmLabel.addEventListener('click', function(e) {
            e.preventDefault();
            var item = $(e.target).closest('.ui.item'),
                id = item.attr('data-id'),
                attachDocUrl = $("#pinnedDocsExt").attr('data-attach-doc-url').replace('0', id);
            $.ajax({
                type: "POST",
                url: attachDocUrl,
                dataType: "json",
                success: function(data) {
                    if (data.status == 200) {
                        item.find('#confirm').remove();
                        var iconRemove = item.find('[data-aim="detach"]')[0];
                        iconRemove.removeEventListener('click', hideDoc);
                        iconRemove.addEventListener('click', detachDoc, false);
                    } else if (data.status == 204) {
                        alert("Document already pinned");
                        item.remove();
                    }
                },
                error: function() {
                    alert("Server error! Document is not attached.")
                }
            })
        }, false)
        placeToPin.append(item);
    }
});
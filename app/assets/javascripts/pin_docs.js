var hideModals = function() {
        $('#addDocModal').modal('hide');
        $('#addDocModal').modal('hide dimmer');
        $('#docUploadChoice').modal('hide');
        $('#docUploadChoice').modal('hide dimmer');
    },
    detachDoc = function(e) {
        e.preventDefault();
        var item = $(e.target).closest('.card'),
            id = item.attr('data-id'),
            $placeToPin = $("#pinnedDocsExt"),
            detachDocUrl = $placeToPin.attr('data-detach-doc-url').replace('0', id),
            $noPinnedDocsStub = $('#noPinnedDocs');
        $.ajax({
            type: "POST",
            url: detachDocUrl,
            dataType: "json",
            success: function() {
                item.remove();
                if ($placeToPin.length == 1)
                    $noPinnedDocsStub.show();
            },
            error: function() {
                alert("Server error! Document is not detached.")
            }
        })
    },
    hideDoc = function(e) {
        var $noPinnedDocsStub = $('#noPinnedDocs'),
            $placeToPin = $("#pinnedDocsExt");
        $(e.target).closest('.card').remove();
        if ($placeToPin.length == 1)
            $noPinnedDocsStub.show();

    },
    createExtendedDoc = function(doc_id, title, description) {
        var item = document.createElement('div'),
            iconAction = document.createElement('i'),
            iconRemove = document.createElement('i'),
            content = document.createElement('div'),
            name = document.createElement('div'),
            desc = document.createElement('div'),
            confirmLabel = document.createElement('div');
        item.setAttribute('class', 'card extended-doc');
        item.setAttribute('data-document', 'attached');
        item.setAttribute('data-id', doc_id);
        confirmLabel.setAttribute('id', 'confirm');
        confirmLabel.setAttribute('class', 'ui bottom attached center aligned green button');
        confirmLabel.appendChild(document.createTextNode(I18n.util.confirm))
        iconAction.setAttribute('class', 'right floated download disk icon');
        iconRemove.setAttribute('class', 'right floated delete icon')
        iconRemove.setAttribute('data-aim', 'detach');
        content.setAttribute('class', 'content');
        name.setAttribute('class', 'header');
        name.appendChild(title);
        desc.setAttribute('class', 'description');
        desc.appendChild(description);
        content.appendChild(iconRemove);
        content.appendChild(iconAction);
        content.appendChild(name);
        content.appendChild(desc);
        item.appendChild(content);
        item.appendChild(confirmLabel);

        iconRemove.addEventListener('click', hideDoc, false)
        confirmLabel.addEventListener('click', function(e) {
            e.preventDefault();
            var item = $(e.target).closest('.card'),
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
                        item.remove();
                    }
                },
                error: function() {
                    alert("Server error! Document is not attached.")
                }
            })
        }, false)
        return item;
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
    var $placeToPin = $('#pinnedDocs'),
        control = e.target,
        title = document.querySelector('#docToPin #title'),
        description = document.querySelector('#docToPin #description'),
        today = new Date(),
        descText = I18n.documents.absent,
        $form = $('#docToPin'),
        $noPinnedDocsStub = $('#noPinnedDocs');
    title.value = control.files[0].name;
    title.setAttribute('data-value', control.files[0].name)
    description.setAttribute('data-value', descText);
    $form.bind('ajax:complete', function() {
        if ($placeToPin.length > 0) {
            var label = document.createElement('div'),
                removeIcon = document.createElement('i');
            label.setAttribute('class', 'ui label');
            removeIcon.setAttribute('class', 'delete icon');
            label.appendChild(document.createTextNode(title.value));
            label.appendChild(removeIcon);
            removeIcon.addEventListener('click', function(e) {
                $(e.target).closest('.ui.label').remove();
            }, false)
            $placeToPin.append(label);
        } else {
            $placeToPin = $('#pinnedDocsExt')
            $.ajax({
                type: "GET",
                url: $form.attr('data-url'),
                data: {
                    'file_name': control.files[0].name,
                    'file_size': control.files[0].size
                },
                dataType: "json",
                success: function(data) {
                    $noPinnedDocsStub.fadeOut();
                    $placeToPin.append(createExtendedDoc(data.doc_id,
                        document.createTextNode(control.files[0].name.trunc(17)),
                        document.createTextNode(descText.trunc(30))));
                }
            })
        }
    });
    $form.submit();
    hideModals();
})

$('input[name="query"]').on('keyup', function(event) {
    var $query = $('#searchDocForm input[name="query"]'),
        $pinnedDocsIds = $('#pinnedDocs input[type="hidden"]').map(function() {
            return parseInt($(this).val())
        });

    // home $, end #
    if (/[a-zA-Z0-9-_.]/.test(String.fromCharCode(event.keyCode))) {
        $.ajax({
            type: "GET",
            url: searchDocForm.getAttribute('data-search-url'),
            data: {
                query: $query.val(),
            },
            dataType: "json",
            success: function(data) {
                var results = document.querySelector("#docSearchResults");
                $(results).empty()
                for (var res in data) {
                    if ($.inArray(data[res].id, $pinnedDocsIds) != -1) {
                        continue;
                    }
                    var item = document.createElement('div'),
                        content = document.createElement('div'),
                        name = document.createElement('div'),
                        title = document.createTextNode((data[res].title ?
                            data[res].title : I18n.documents.no_title).trunc(17)),
                        description = document.createElement('p'),
                        desc = document.createTextNode((data[res].description ?
                            data[res].description : I18n.documents.no_description).trunc(30)),
                        type = document.createElement('i'),
                        selectLabel = document.createElement('a'),
                        selectIcon = document.createElement('i'),
                        select = function(e) {
                            var item = $(e.target).closest('div.card'),
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

                    item.setAttribute('class', 'card');
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
});

$('[data-aim="detach"]').on('click', detachDoc)

$('button#pinDocsExt').on('click', function(event) {
    event.preventDefault();
    var pinnedDocs = $('#docSearchResults div[data-pinned="true"]').get(),
        $placeToPin = $('#pinnedDocsExt'),
        $noPinnedDocsStub = $('#noPinnedDocs');
    hideModals();
    if ($noPinnedDocsStub.length != 0)
        $noPinnedDocsStub.fadeOut();
    for (var cur in pinnedDocs) {
        var $doc = $(pinnedDocs[cur]);
        $placeToPin.append(createExtendedDoc(pinnedDocs[cur].getAttribute('data-id'),
            document.createTextNode($doc.find('div[data-attr="name"]').html()),
            document.createTextNode($doc.find('p[data-attr="desc"]').html())));
    }
});
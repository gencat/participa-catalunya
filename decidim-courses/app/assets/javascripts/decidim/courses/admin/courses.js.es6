$(() => {
  ((exports) => {
    const $courseScopeEnabled = $("#course_scopes_enabled");
    const $courseScopeId = $("#course_scope_id");
    const $form = $(".edit_course, .new_course");

    if ($form.length > 0) {
      $courseScopeEnabled.on("change", (event) => {
        const checked = event.target.checked;
        exports.theDataPicker.enabled($courseScopeId, checked);
      })
      exports.theDataPicker.enabled($courseScopeId, $courseScopeEnabled.prop("checked"));

      const $registrationsEnabled = $form.find("#course_registrations_enabled");
      const $availableSlots = $form.find("#course_available_slots");
      const toggleDisabledFields = () => {
        const enabled = $registrationsEnabled.prop("checked");
        $availableSlots.attr("disabled", !enabled);

        $form.find("#course_registrations_terms .editor-container").each((idx, node) => {
          const quill = Quill.find(node);
          quill.enable(enabled);
        })
      };
      $registrationsEnabled.on("change", toggleDisabledFields);
      toggleDisabledFields();
    }

  })(window);
});

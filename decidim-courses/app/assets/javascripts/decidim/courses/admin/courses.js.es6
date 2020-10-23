$(() => {
  ((exports) => {
    const $courseScopeEnabled = $("#course_scopes_enabled");
    const $courseScopeId = $("#course_scope_id");

    if ($(".edit_course, .new_course").length > 0) {
      $courseScopeEnabled.on("change", (event) => {
        const checked = event.target.checked;
        exports.theDataPicker.enabled($courseScopeId, checked);
      })
      exports.theDataPicker.enabled($courseScopeId, $courseScopeEnabled.prop("checked"));
    }
  })(window);
});

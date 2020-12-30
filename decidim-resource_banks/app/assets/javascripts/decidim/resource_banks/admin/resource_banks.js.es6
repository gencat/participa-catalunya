$(() => {
  ((exports) => {
    const $resourceBankScopeEnabled = $("#resource_bank_scopes_enabled");
    const $resourceBankScopeId = $("#resource_bank_scope_id");

    if ($(".edit_resource_bank, .new_resource_bank").length > 0) {
      $resourceBankScopeEnabled.on("change", (event) => {
        const checked = event.target.checked;
        exports.theDataPicker.enabled($resourceBankScopeId, checked);
      })
      exports.theDataPicker.enabled($resourceBankScopeId, $resourceBankScopeEnabled.prop("checked"));
    }
  })(window);
});

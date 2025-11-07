module PageActionsHelper
  # Merender deretan aksi halaman dalam layout KT konsisten.
  # Parameter:
  # - actions: Array elemen HTML (mis. hasil link_to) yang akan ditata berderet.
  # Return: HTML safe string hasil render partial shared/page_actions.
  def page_actions(actions)
    render 'shared/page_actions', actions: actions
  end
end
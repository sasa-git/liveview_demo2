defmodule ChirpWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.post_index_path(@socket, :index)}>
        <.live_component
          module={ChirpWeb.PostLive.FormComponent}
          id={@post.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.post_index_path(@socket, :index)}
          post: @post
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def modal_sample(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="fade-in-scale phx-modal-content"
        phx-click-away={Phoenix.LiveView.JS.push("close", target: @target)}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        @id=<%= @id %>, @target=<%= @target %> 
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def modal_sample2(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id={@id} class="modal phx-modal" style="display: none;">
      <div class="phx-modal-content fade-in-scale"
      phx-click-away={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}
      phx-window-keydown={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}
      phx-key="escape"
      >
        My Modal #<%= @id %>
        Detail: <a href="https://hexdocs.pm/phoenix_live_view/bindings.html#js-commands" target="_blank">https://hexdocs.pm/phoenix_live_view/bindings.html#js-commands</a>
        <button phx-click={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}>
          hide modal
        </button>
      </div>
    </div>
    
    <button phx-click={Phoenix.LiveView.JS.show(to: "##{@id}", transition: "fade-in")}>
      show modal
    </button>
    
    <button phx-click={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}>
      hide modal
    </button>
    
    <button phx-click={Phoenix.LiveView.JS.toggle(to: "##{@id}", in: "fade-in", out: "fade-out")}>
      toggle modal
    </button>
    """
  end

  def modal_sample3(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id={@id} class="modal phx-modal" style="display: none;">
      <div class="phx-modal-content fade-in-scale"
      phx-click-away={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}
      phx-window-keydown={Phoenix.LiveView.JS.hide(to: "##{@id}", transition: "fade-out")}
      phx-key="escape"
      >
        <%= render_slot(@inner_block, @id) %>
      </div>
    </div>
    
    <button phx-click={Phoenix.LiveView.JS.show(to: "##{@id}", transition: "fade-in")}>
      show modal
    </button>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end

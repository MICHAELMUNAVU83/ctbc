defmodule CtbcWeb.EventLive.BuyTicketPromoCodeComponent do
  use CtbcWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div id="myModal" class="modal">
        <div class="modal-content pt-12 ">
          <%= if @payment_state == "initiated" do %>
            <div class="bg-gray-100 rounded-md min-h-[450px] p-2 ">
              <.form let={f} for={@changeset} id="mpesa-form" phx_change="validate" phx_submit="pay">
                <div class="flex flex-col p-2 items-start">
                  <p class="jakrata-regular text-2xl">Pay with Mpesa</p>
                  <div class="flex gap-2 items-center">
                    <p class="bg-black h-[10px] w-[10px] rotate-45" />
                    <p class="bg-red-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-green-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-yellow-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-black h-[10px] w-[10px] rotate-45" />
                    <p class="bg-red-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-green-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-yellow-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-black h-[10px] w-[10px] rotate-45" />
                    <p class="bg-red-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-green-500 h-[10px] w-[10px] rotate-45" />
                    <p class="bg-yellow-500 h-[10px] w-[10px] rotate-45" />
                  </div>
                </div>
                <p class="  h-[2px] my-2 bg-gradient-to-r from-green-300  via-green-700 to-black   w-[100%]" />
                <div class="flex  px-2 gap-2 items-center">
                  <p class="bg-gradient-to-tl  from-green-500 line-through  via-green-700 to-black px-8 to-black py-2 text-xl  rounded-md text-white">
                    Ksh <%= @event.price %> per ticket
                  </p>
                  <p class="bg-gradient-to-tl  from-green-500  via-green-700 to-black px-8 to-black py-2 text-xl  rounded-md text-white">
                    Ksh <%= String.to_integer(@event.price) * 0.9 %> per ticket
                  </p>
                </div>
                <div class="w-[100%] flex  md:flex-row flex-col justify-between">
                  <div class="md:w-[48%]">
                    <p>
                      Enter your Name
                    </p>

                    <div>
                      <%= text_input(f, :name,
                        placeholder: "Full Name",
                        class:
                          "w-[100%] rounded-md  h-[40px] focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                      ) %>
                    </div>
                    <p class="pt-5">
                      <%= error_tag(f, :name) %>
                    </p>
                  </div>
                  <div class="md:w-[48%] ">
                    <p>
                      Enter your Email
                    </p>

                    <div>
                      <%= text_input(f, :email,
                        placeholder: "customer@gmail.com",
                        class:
                          "w-[100%] rounded-md  h-[40px] focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                      ) %>
                    </div>
                    <p class="pt-5">
                      <%= error_tag(f, :email) %>
                    </p>
                  </div>
                </div>
                <div>
                  <p>
                    Enter your Mpesa Number to get a prompt
                  </p>

                  <p class="text-red-500 text-sm">
                    *Ensure the phone number starts with 254 , e.g 254712345678
                  </p>
                  <div>
                    <%= text_input(f, :phone_number,
                      placeholder: "254712345678",
                      class:
                        "w-[100%] rounded-md  h-[40px] focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    ) %>
                  </div>
                  <p class="pt-5">
                    <%= error_tag(f, :phone_number) %>
                  </p>
                </div>
                <div class="my-2">
                  <p>
                    Enter Number of Tickets
                  </p>
                  <%= select(f, :no_of_tickets, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                    prompt: "Select the number of tickets",
                    class:
                      "w-[100%] rounded-md focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  ) %>
                  <p class="pt-5">
                    <%= error_tag(f, :no_of_tickets) %>
                  </p>
                </div>

                <div>
                  <p>
                    Select how you want to receive your ticket
                  </p>
                  <div>
                    <%= select(f, :deliver_ticket_by, ["SMS", "Email Address"],
                      prompt: "Select ",
                      class:
                        "w-[100%] rounded-md  h-[40px] focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    ) %>
                  </div>
                  <p class="pt-5">
                    <%= error_tag(f, :deliver_ticket_by) %>
                  </p>
                </div>

                <%= if @number_of_tickets != "" do %>
                  <p class="p-2 jakrata-regular text-xl text-center">
                    The total cost for <%= @number_of_tickets %> <%= if String.to_integer(
                                                                          @number_of_tickets
                                                                        ) == 1 do
                      "ticket"
                    else
                      "tickets"
                    end %> is Ksh <%= @total_cost %>
                  </p>
                <% end %>

                <div class="flex flex-col w-[100%] p-2 items-start">
                  <%= submit("Buy Ticket",
                    phx_disable_with: "Submitting Payment",
                    class:
                      "bg-gradient-to-l w-[80%] mx-auto rounded-md  text-white  uppercase font-semibold py-2 hover:scale-105 transition-all ease-in-out transition-all duration-500 cursor-pointer from-green-200  via-green-500 to-black"
                  ) %>
                </div>
              </.form>
            </div>
          <% else %>
            <div class="bg-gray-100 flex rounded-md flex-col justify-center items-center gap-8 h-[450px] p-2 ">
              <p class="bg-yellow-400 w-[80%] mx-auto p-4 rounded-md text-xl text-center">
                A Prompt has been sent  to your phone to pay Ksh <%= @total_cost %> for <%= @ticket_number %> tickets .
                Kindly complete the payment to get your ticket and once you are done , click the confirm button below.
              </p>
              <div class="flex justify-center items-center">
                <button
                  phx-click="check"
                  phx-disable-with="Confirming Payment.."
                  class="bg-gradient-to-l px-8  mx-auto rounded-md  text-white  uppercase font-semibold py-2 hover:scale-105 transition-all ease-in-out transition-all duration-500 cursor-pointer from-green-400  via-green-500 to-black"
                >
                  Confirm
                </button>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

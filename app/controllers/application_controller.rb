class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication
  include SvgIconsHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_sidebar_menu

  def set_sidebar_menu
    @sidebar_menus = [
      { name: "Dashboard", path: "/", icon: dashboard },
      { name: "Communities", path: "/communities", icon: community }
      # { name: "Orders", path: "/orders", icon: orders, role: "admin user supplier" },
      # { name: "Suppliers", path: "/suppliers", icon: orders, role: "admin user" },
      # {
      #   name: "Product", icon: products, role: "supplier", submenu: [
      #     { name: "Products", path: "/products" },
      #     { name: "Inventory", path: "/inventories" },
      #     { name: "Category", path: "/categories" }
      #   ]
      # },
      # { name: "Payments", path: "/payments", icon: payments, role: "admin user supplier" }
    ]
  end
end

# Helper methods for the Finances views.
module FinancesHelper
  # Returns a Tailwind CSS class string for styling a payment status badge.
  #
  # The returned string always includes base pill classes (small text, horizontal
  # padding, vertical padding, and fully rounded corners) combined with
  # status-specific foreground and background colours that support both light
  # and dark mode:
  #
  #   completed  – green
  #   pending    – yellow
  #   failed     – red
  #   processing – blue
  #   (other)    – gray  (fallback for any unrecognised status)
  #
  # @param status [String, Symbol] the payment status value
  # @return [String] a space-separated list of Tailwind CSS utility classes
  def payment_status_class(status)
    base_classes = "text-xs px-2 py-0.5 rounded-full"

    case status.to_s
    when "completed"
      "#{base_classes} bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
    when "pending"
      "#{base_classes} bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200"
    when "failed"
      "#{base_classes} bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
    when "processing"
      "#{base_classes} bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200"
    else
      "#{base_classes} bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200"
    end
  end
end

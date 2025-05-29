module FinancesHelper
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

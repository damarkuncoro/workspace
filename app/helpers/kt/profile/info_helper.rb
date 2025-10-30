module KT::Profile::InfoHelper
  # Profile Info Section
  def profile_info_section(person:, customer: nil, employee: nil)
    safe_join([
      content_tag(:div, class: "profile-info") do
        safe_join([
          content_tag(:p) do
            content_tag(:strong, "Name:") + " #{person.name || 'Not provided'}"
          end,
          content_tag(:p) do
            content_tag(:strong, "Date of Birth:") + " #{person.date_of_birth ? l(person.date_of_birth) : 'Not provided'}"
          end
        ])
      end,
      customer ? content_tag(:div, class: "customer-info") do
        safe_join([
          content_tag(:p) do
            content_tag(:strong, "Customer Code:") + " #{customer.customer_code || 'Not registered'}"
          end,
          content_tag(:p) do
            content_tag(:strong, "Status:") + " #{customer.status || 'Not registered'}"
          end,
          content_tag(:p) do
            content_tag(:strong, "Registered At:") + " #{customer.created_at ? l(customer.created_at) : 'Not registered'}"
          end
        ])
      end : nil,
      employee ? content_tag(:div, class: "employee-info") do
        safe_join([
          content_tag(:p) do
            content_tag(:strong, "Employee Code:") + " #{employee.employee_code || 'Not registered'}"
          end,
          content_tag(:p) do
            content_tag(:strong, "Status:") + " #{employee.status || 'Not registered'}"
          end,
          content_tag(:p) do
            content_tag(:strong, "Registered At:") + " #{employee.created_at ? l(employee.created_at) : 'Not registered'}"
          end
        ])
      end : nil
    ].compact)
  end
end
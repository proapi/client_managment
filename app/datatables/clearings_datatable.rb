class ClearingsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Clearing.count,
        iTotalDisplayRecords: clearings.total_entries,
        aaData: data
    }
  end

  private

  def data
    clearings.map do |clearing|
      [
          link_to(clearing.name, clearing),
          h(clearing),
          h(product.released_on.strftime("%B %e, %Y")),
          number_to_currency(product.price)
      ]
    end
  end

  def clearings
    @clearings ||= fetch_clearings
  end

  def fetch_clearings
    clearings = Clearing.order("#{sort_column} #{sort_direction}")
    clearings = clearings.page(page).per_page(per_page)
    if params[:sSearch].present?
      clearings = clearings.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    clearings
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
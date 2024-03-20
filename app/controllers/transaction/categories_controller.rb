class Transaction::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[ show update destroy ]

  def show
  end

  def create
    @category = Current.family.transaction_categories.build(category_params)

    respond_to do |format|
      if @category.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("notification-tray", partial: "shared/notification", locals: { type: "success", content: t(".success") })
          ]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("notification-tray", partial: "shared/notification", locals: { type: "success", content: t(".success") }),
            turbo_stream.replace(dom_id(category), partial: "accounts/account", locals: { account: @account })
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("notification-tray", partial: "shared/notification", locals: { type: "success", content: t(".success") })
        ]
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Transaction::Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:transaction_category).permit(:name, :color)
    end
end

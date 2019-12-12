# frozen_string_literal: true

module CRUDContext
  def permission(context:)
    raise 'not a valid session' unless context[:current_user].present?
  end

  def create(context:, params:)
    permission(context)
    create(params)
  end

  def read(context:, params:)
    permission(context)
    where(params)
  end

  def update(context:, params:, update_params:)
    permission(context)
    where(params).update_all(update_params)
  end

  def delete(context:, params:)
    permission(context: context)
    where(params).destroy_all
  end
end

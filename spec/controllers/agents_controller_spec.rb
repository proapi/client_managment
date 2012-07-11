require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AgentsController do

  # This should return the minimal set of attributes required to create a valid
  # Agent. As you add validations to Agent, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AgentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all agents as @agents" do
      agent = Agent.create! valid_attributes
      get :index, {}, valid_session
      assigns(:agents).should eq([agent])
    end
  end

  describe "GET show" do
    it "assigns the requested agent as @agent" do
      agent = Agent.create! valid_attributes
      get :show, {:id => agent.to_param}, valid_session
      assigns(:agent).should eq(agent)
    end
  end

  describe "GET new" do
    it "assigns a new agent as @agent" do
      get :new, {}, valid_session
      assigns(:agent).should be_a_new(Agent)
    end
  end

  describe "GET edit" do
    it "assigns the requested agent as @agent" do
      agent = Agent.create! valid_attributes
      get :edit, {:id => agent.to_param}, valid_session
      assigns(:agent).should eq(agent)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Agent" do
        expect {
          post :create, {:agent => valid_attributes}, valid_session
        }.to change(Agent, :count).by(1)
      end

      it "assigns a newly created agent as @agent" do
        post :create, {:agent => valid_attributes}, valid_session
        assigns(:agent).should be_a(Agent)
        assigns(:agent).should be_persisted
      end

      it "redirects to the created agent" do
        post :create, {:agent => valid_attributes}, valid_session
        response.should redirect_to(Agent.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved agent as @agent" do
        # Trigger the behavior that occurs when invalid params are submitted
        Agent.any_instance.stub(:save).and_return(false)
        post :create, {:agent => {}}, valid_session
        assigns(:agent).should be_a_new(Agent)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Agent.any_instance.stub(:save).and_return(false)
        post :create, {:agent => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested agent" do
        agent = Agent.create! valid_attributes
        # Assuming there are no other agents in the database, this
        # specifies that the Agent created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Agent.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => agent.to_param, :agent => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested agent as @agent" do
        agent = Agent.create! valid_attributes
        put :update, {:id => agent.to_param, :agent => valid_attributes}, valid_session
        assigns(:agent).should eq(agent)
      end

      it "redirects to the agent" do
        agent = Agent.create! valid_attributes
        put :update, {:id => agent.to_param, :agent => valid_attributes}, valid_session
        response.should redirect_to(agent)
      end
    end

    describe "with invalid params" do
      it "assigns the agent as @agent" do
        agent = Agent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Agent.any_instance.stub(:save).and_return(false)
        put :update, {:id => agent.to_param, :agent => {}}, valid_session
        assigns(:agent).should eq(agent)
      end

      it "re-renders the 'edit' template" do
        agent = Agent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Agent.any_instance.stub(:save).and_return(false)
        put :update, {:id => agent.to_param, :agent => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested agent" do
      agent = Agent.create! valid_attributes
      expect {
        delete :destroy, {:id => agent.to_param}, valid_session
      }.to change(Agent, :count).by(-1)
    end

    it "redirects to the agents list" do
      agent = Agent.create! valid_attributes
      delete :destroy, {:id => agent.to_param}, valid_session
      response.should redirect_to(agents_url)
    end
  end

end

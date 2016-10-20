--Cyber Virus
function c59375850.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCost(c59375850.cost)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c59375850.condition)
	e1:SetTarget(c59375850.target)
	e1:SetOperation(c59375850.operation)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCost(c59375850.thcost)
	e2:SetCondition(aux.exccon)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(59375850,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c59375850.tdtg)
	e2:SetOperation(c59375850.tdop)
	c:RegisterEffect(e2)
end
function c59375850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c59375850.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(RACE_MACHINE)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function c59375850.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c59375850.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59375850.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c59375850.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c59375850.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,70095154)
end
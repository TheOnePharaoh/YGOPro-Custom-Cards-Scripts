--The Panticle Gear
function c80106531.initial_effect(c)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetCondition(c80106531.desrepcon)
	e2:SetTarget(c80106531.desreptg)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80106531,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c80106531.tdcon)
	e3:SetCost(c80106531.tdcost)
	e3:SetTarget(c80106531.tdtg)
	e3:SetOperation(c80106531.tdop)
	c:RegisterEffect(e3)
end
function c80106531.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c80106531.desrepcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and not Duel.IsExistingMatchingCard(c80106531.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80106531.cfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c80106531.filter(c)
	return c:IsSetCard(0xca00)
end
function c80106531.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c80106531.filter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(80106531,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c80106531.filter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c80106531.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80106531.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c80106531.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c80106531.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end

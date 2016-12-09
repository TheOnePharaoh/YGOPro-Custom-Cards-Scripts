--Seafarer Undead Unagi
function c66666696.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x669),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666696,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
--	e2:SetCost(c66666696.cost)
	e2:SetTarget(c66666696.settg)
	e2:SetOperation(c66666696.setop)
	c:RegisterEffect(e2)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c66666696.atkval)
	c:RegisterEffect(e5)
end

function c66666696.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,0,LOCATION_SZONE,nil,TYPE_SPELL+TYPE_TRAP)*100
end


function c66666696.cstfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c66666696.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end

function c66666696.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)and(c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)<100)
end
function c66666696.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c66666696.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c66666696.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp)and
	Duel.IsExistingMatchingCard(c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66666696.setop(e,tp,eg,ep,ev,re,r,rp)
	local cst=Duel.GetFirstTarget()
	if Duel.Destroy(cst,REASON_EFFECT)~=0 then
		local g=Duel.SelectTarget(tp,c66666696.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

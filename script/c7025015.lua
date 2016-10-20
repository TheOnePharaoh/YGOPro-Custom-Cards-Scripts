--Earthbound Immortal Huacachina Kon
function c7025015.initial_effect(c)
	c:SetUniqueOnField(1,1,10000000)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c7025015.sdcon)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7025015,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c7025015.destg)
	e4:SetOperation(c7025015.desop)
	c:RegisterEffect(e4)
	--destroy2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7025015,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c7025015.descon2)
	e5:SetTarget(c7025015.destg2)
	e5:SetOperation(c7025015.desop2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e7)
end
function c7025015.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c7025015.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21)
end
function c7025015.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c7025015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c7025015.cfilter,tp,LOCATION_MZONE,0,nil)
		local dt=Duel.GetMatchingGroupCount(c7025015.filter,tp,0,LOCATION_ONFIELD,nil)
		e:SetLabel(ct)
		return dt>=ct
	end
	local g=Duel.GetMatchingGroup(c7025015.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,e:GetLabel(),0,0)
end
function c7025015.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c7025015.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c7025015.filter,tp,0,LOCATION_ONFIELD,nil)
	if ct>g:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,ct,ct,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c7025015.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c7025015.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7025015.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

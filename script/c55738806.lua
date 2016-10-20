--Malefic Ultima Dragon
function c55738806.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,55738804),aux.FilterBoolFunction(Card.IsSetCard,0x23),true)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,55738806)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c55738806.descon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55738806,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c55738806.discon)
	e2:SetTarget(c55738806.distg)
	e2:SetOperation(c55738806.disop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c55738806.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c55738806.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c55738806.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c55738806.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
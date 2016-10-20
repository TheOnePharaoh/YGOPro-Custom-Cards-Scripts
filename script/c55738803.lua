--Sin chimera dragon
function c55738803.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsCode,74509280),aux.NonTuner(Card.IsSetCard,0x23))
	c:EnableReviveLimit()
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c55738803.descon)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgval)
	c:RegisterEffect(e2)
	--Negate summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(55738803,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c55738803.discon)
	e5:SetTarget(c55738803.distg)
	e5:SetOperation(c55738803.disop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(55738803,1))
	e6:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetDescription(aux.Stringid(55738803,2))
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
end
function c55738803.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c55738803.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c55738803.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c55738803.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

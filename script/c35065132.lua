--Vocaloid Kasane Teto Final Form
function c35065132.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c35065132.efilter)
	c:RegisterEffect(e2)
	--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c35065132.antarget)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c35065132.atkval)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(35065132,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c35065132.condition)
	e5:SetCost(c35065132.cost)
	e5:SetTarget(c35065132.target)
	e5:SetOperation(c35065132.operation)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(35065132,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1)
	e6:SetTarget(c35065132.sptg)
	e6:SetOperation(c35065132.spop)
	c:RegisterEffect(e6)
end
function c35065132.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c35065132.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c35065132.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c35065132.antarget(e,c)
	return c~=e:GetHandler()
end
function c35065132.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c35065132.atkval(e,c)
	return Duel.GetMatchingGroupCount(c35065132.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*500
end
function c35065132.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c35065132.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c35065132.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c35065132.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(35065132,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,1)
end
function c35065132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(35065132)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c35065132.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
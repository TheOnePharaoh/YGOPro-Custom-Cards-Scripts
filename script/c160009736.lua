--Mail Skull Harpie
function c160009736.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,500314775,aux.FilterBoolFunction(Card.IsSetCard,0x64),1,true,true)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,5))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160009736,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c160009736.concon)
	e2:SetCost(c160009736.concost)
	e2:SetOperation(c160009736.conop)
	c:RegisterEffect(e2)
end
function c160009736.concon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN) and bit.band(r,0x41)==0x41 and rp~=tp
end
function c160009736.concost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c160009736.confilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c160009736.conop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c160009736.confilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1079,1,REASON_EFFECT)
		tc=g:GetNext()
	end
end

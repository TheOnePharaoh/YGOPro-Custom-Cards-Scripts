--Toon Big Al
function c57888885.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c57888885.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c57888885.spcon)
	e2:SetOperation(c57888885.spop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c57888885.atklimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c57888885.dircon)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(57888885,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c57888885.tg)
	e7:SetOperation(c57888885.op)
	c:RegisterEffect(e7)
end
function c57888885.confilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888885.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(c57888885.confilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,1,nil,TYPE_TOON)
end
function c57888885.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(c57888885.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c57888885.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888885.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsType,1,1,nil,TYPE_TOON)
	Duel.Release(g,REASON_COST)
end
function c57888885.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888885.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888885.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888885.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888885.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888885.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c57888885.spefilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c57888885.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57888885.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c57888885.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57888885.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
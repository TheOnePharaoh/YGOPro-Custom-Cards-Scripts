--Toon Hatsune Miku
function c57888881.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c57888881.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c57888881.spcon1)
	e2:SetOperation(c57888881.spop1)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c57888881.atklimit)
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
	e6:SetCondition(c57888881.dircon)
	c:RegisterEffect(e6)
	--banish
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(57888881,0))
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c57888881.remcon)
	e7:SetTarget(c57888881.remtg)
	e7:SetOperation(c57888881.remop)
	c:RegisterEffect(e7)
	--Special Summon2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(57888881,1))
	e8:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCondition(c57888881.spcon2)
	e8:SetCost(c57888881.spcost)
	e8:SetTarget(c57888881.sptg)
	e8:SetOperation(c57888881.spop2)
	c:RegisterEffect(e8)
end
function c57888881.confilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888881.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(c57888881.confilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,1,nil,TYPE_TOON)
end
function c57888881.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(c57888881.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c57888881.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888881.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsType,1,1,nil,TYPE_TOON)
	Duel.Release(g,REASON_COST)
end
function c57888881.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888881.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888881.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888881.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888881.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888881.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c57888881.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888881.remcon(e)
	return not Duel.IsExistingMatchingCard(c57888881.confilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c57888881.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		if tc:IsFaceup() and not tc:IsType(TYPE_TOON) then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	end
end
function c57888881.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_TOON) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c57888881.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c57888881.costfilter(c)
	return c:IsLevelAbove(1) and c:IsType(TYPE_TOON) and not c:IsCode(57888881) and c:IsAbleToRemoveAsCost()
end
function c57888881.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57888881.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c57888881.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c57888881.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c57888881.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end

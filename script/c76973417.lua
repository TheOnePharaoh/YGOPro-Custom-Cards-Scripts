--Corrupted Vocaloid Teto Kasane Type - 00
function c76973417.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76973417,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c76973417.sumtg)
	e1:SetOperation(c76973417.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--synchro summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(c76973417.synlimit)
	c:RegisterEffect(e5)
	--level change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetCondition(c76973417.lvcon)
	e4:SetValue(12)
	c:RegisterEffect(e4)
	--add setcode
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x0dac405)
	c:RegisterEffect(e6)
end
function c76973417.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TUNER)
end
function c76973417.lvcon(e)
	return Duel.IsExistingMatchingCard(c76973417.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c76973417.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76973417.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c76973417.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c76973417.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76973417.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c76973417.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c76973417.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 or code==76973411 or code==76973412 or code==76973415 or code==76973416 or code==76973418 or code==76973419 or code==76973420 or code==76973421 then
	return else return not c:IsSetCard(0x301) end
end
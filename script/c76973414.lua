--Corrupted Vocaloid Kamui Gakupo Type - 00
function c76973414.initial_effect(c)
	c:SetSPSummonOnce(76973414)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76973414.spcon)
	e1:SetOperation(c76973414.spop)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c76973414.synlimit)
	c:RegisterEffect(e2)
	--be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c76973414.effcon)
	e3:SetOperation(c76973414.effop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76973414,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,76973414)
	e4:SetTarget(c76973414.sptg2)
	e4:SetOperation(c76973414.spop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--add setcode
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x0dac405)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(76973414,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCondition(c76973414.drcon)
	e7:SetTarget(c76973414.drtg)
	e7:SetOperation(c76973414.drop)
	c:RegisterEffect(e7)
end
function c76973414.spfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76973414.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c76973414.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c76973414.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76973414.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c76973414.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local lv=Duel.TossDice(tp,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(lv)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c76973414.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 or code==76973411 or code==76973412 or code==76973415 or code==76973416 or code==76973418 or code==76973419 or code==76973420 or code==76973421 then
	return else return not c:IsSetCard(0x301) end
end
function c76973414.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c76973414.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(76973414,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c76973414.drcon)
	e1:SetTarget(c76973414.drtg)
	e1:SetOperation(c76973414.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c76973414.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c76973414.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76973414.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c76973414.spfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsCode(76973414)
end
function c76973414.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c76973414.spfilter,c:GetControler(),LOCATION_DECK,0,1,c)
end
function c76973414.specfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TUNER) and not c:IsCode(76973414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76973414.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c76973414.specfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c76973414.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c76973414.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76973414.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--Accel Vocaloid Makune Hachi
function c74140840.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74140840,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c74140840.rmcon)
	e1:SetTarget(c74140840.rmtg)
	e1:SetOperation(c74140840.rmop)
	c:RegisterEffect(e1)
	--Synchro Related
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74140840,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c74140840.spcon)
	e2:SetTarget(c74140840.sptg)
	e2:SetOperation(c74140840.spop)
	c:RegisterEffect(e2)
	--Spsummon and mod lvl
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74140840,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,74140840)
	e3:SetCondition(c74140840.spcon2)
	e3:SetTarget(c74140840.sptg2)
	e3:SetOperation(c74140840.spop2)
	c:RegisterEffect(e3)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
end
function c74140840.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local bpc1=(ph==PHASE_BATTLE or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()))
	local bpc2=false
	if PHASE_BATTLE_START then bpc2=(ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or bpc1 or bpc2)
end
function c74140840.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c74140840.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c74140840.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c74140840.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE) and c:IsAbleToRemove()
end
function c74140840.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74140840.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c74140840.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c74140840.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c74140840.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c74140840.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c74140840.spfil(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and not c:IsCode(74140840) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74140840.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c74140840.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c74140840.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c74140840.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c74140840.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		local lv=Duel.TossDice(tp,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(lv)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		tc:RegisterEffect(e2)
	end
end
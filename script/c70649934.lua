-- ADE Kiaraa
function c70649934.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649934,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c70649934.sumtg)
	e1:SetOperation(c70649934.sumop)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649934,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c70649934.sccon)
	e2:SetTarget(c70649934.sctarg)
	e2:SetOperation(c70649934.scop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649934,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c70649934.drcon)
	e3:SetTarget(c70649934.drtg)
	e3:SetOperation(c70649934.drop)
	c:RegisterEffect(e3)
end
function c70649934.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649934.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70649934.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c70649934.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70649934.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		tc:RegisterFlagEffect(70649934,RESET_EVENT+0x1fe0000,0,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabelObject(tc)
		e3:SetCondition(c70649934.descon)
		e3:SetOperation(c70649934.desop)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.SpecialSummonComplete() then
		local g2=Duel.SelectTarget(tp,c70649934.dekfilter,tp,LOCATION_DECK,0,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,2,0,0)
		local tc2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(tc2,REASON_EFFECT)
	end
end
function c70649934.dekfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) and not c:IsCode(70649934) and c:IsDestructable()
end
function c70649934.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(70649934)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c70649934.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c70649934.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c70649934.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c70649934.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c70649934.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649934.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c70649934.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

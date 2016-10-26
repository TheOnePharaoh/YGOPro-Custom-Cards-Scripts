--Vocaloid Stardust
function c84435256.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84435256,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,84435256)
	e1:SetCondition(c84435256.spcon)
	e1:SetTarget(c84435256.sptg)
	e1:SetOperation(c84435256.spop)
	c:RegisterEffect(e1)
	--eff gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c84435256.effcon)
	e2:SetOperation(c84435256.effop)
	c:RegisterEffect(e2)
	--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c84435256.con)
	e3:SetTarget(c84435256.tg)
	e3:SetOperation(c84435256.op)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCost(c84435256.cost)
	e4:SetTarget(c84435256.target)
	e4:SetOperation(c84435256.operation)
	c:RegisterEffect(e4)
	--nontuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e5)
end
function c84435256.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c84435256.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84435256.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP)
	end
end
function c84435256.effcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c84435256.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c84435256.sccon)
	e1:SetTarget(c84435256.sctg)
	e1:SetOperation(c84435256.scop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c84435256.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local bpc1=((ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()))
	local bpc2=false
	if PHASE_BATTLE_START then bpc2=(ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or bpc1 or bpc2)
end
function c84435256.mfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c84435256.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c84435256.mfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
		return g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84435256.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c84435256.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
	end
end
function c84435256.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c84435256.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c84435256.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x0dac405) and rc:IsFaceup() and rc:IsOnField() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(700)
		rc:RegisterEffect(e1)
	end
end
function c84435256.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c84435256.cfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c84435256.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c84435256.cfilter,1,nil,e,tp) end
	local g=eg:Filter(c84435256.cfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c84435256.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end


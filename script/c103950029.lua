--Petit Guardian Draco
function c103950029.initial_effect(c)
	
	--Gain LP (before battle damage)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950029,0))
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c103950029.lpcon1)
	e1:SetCost(c103950029.lpcost)
	e1:SetTarget(c103950029.lptgt1)
	e1:SetOperation(c103950029.lpop)
	c:RegisterEffect(e1)
	
	--Gain LP (before effect damage)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c103950029.lpcon2)
	e2:SetTarget(c103950029.lptgt2)
	c:RegisterEffect(e2)
	
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103950029,1))
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_HAND)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_RECOVER)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c103950029.spcon)
	e3:SetTarget(c103950029.sptg)
	e3:SetOperation(c103950029.spop)
	c:RegisterEffect(e3)
	
end

--Gain LP cost
function c103950029.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,103950029)==0 end
	Duel.RegisterFlagEffect(tp,103950029,0,0,0)
end

--Gain LP operation
function c103950029.lpop(e,tp,eg,ep,ev,re,r,rp)

	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	
	Duel.BreakEffect()
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

--Gain LP condition (before battle damage)
function c103950029.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

--Gain LP target (before battle damage)
function c103950029.lptgt1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	local rec = Duel.GetBattleDamage(tp)/2
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end

--Gain LP condition (before effect damage)
function c103950029.lpcon2(e,tp,eg,ep,ev,re,r,rp)

	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==PLAYER_ALL or cp==tp) then return true end
	
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if not ex then return false end
	
	return Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end

--Gain LP target (before effect damage)
function c103950029.lptgt2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if not ex then
		ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	end
	
	local rec = cv/2
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end

--Special Summmon condition
function c103950029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not re:GetHandler():IsCode(103950029) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

--Special Summon target
function c103950029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Special Summon operation
function c103950029.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
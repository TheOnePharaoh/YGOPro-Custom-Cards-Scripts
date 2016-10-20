--Vocalist Laboratory
function c44646230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c44646230.tg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44646230,0))
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DRAW)
	e3:SetCondition(c44646230.drcon)
	e3:SetCost(c44646230.drcost)
	e3:SetTarget(c44646230.drtg)
	e3:SetOperation(c44646230.drop)
	c:RegisterEffect(e3)
	--non targetable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c44646230.tgtg)
	e4:SetValue(c44646230.tgval)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(44646230,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c44646230.spcon)
	e5:SetTarget(c44646230.sptg)
	e5:SetOperation(c44646230.spop)
	c:RegisterEffect(e5)
end
function c44646230.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c44646230.filter(c)
	return c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228) and not c:IsPublic()
end
function c44646230.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c44646230.filter,1,nil) end
	local g=eg:Filter(c44646230.filter,nil)
	if g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
end
function c44646230.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44646230.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c44646230.tg(e,c)
	return c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228)
end
function c44646230.tgtg(e,c)
	return c:IsFaceup() and c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228)
end
function c44646230.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44646230.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c44646230.filter2(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=9
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c44646230.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44646230.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c44646230.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44646230.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc:CompleteProcedure()
	end
end
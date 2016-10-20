--CXyz Mechquipped Neo Bahamut
function c19007857.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c19007857.poscon)
	e1:SetTarget(c19007857.postg)
	e1:SetOperation(c19007857.posop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19007857,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c19007857.drcon)
	e2:SetTarget(c19007857.drtg)
	e2:SetOperation(c19007857.drop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c19007857.sumlimit)
	e3:SetCondition(c19007857.dscon)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19007857,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1)
	e4:SetCondition(c19007857.dscon)
	e4:SetCost(c19007857.atkcost)
	e4:SetTarget(c19007857.atktg)
	e4:SetOperation(c19007857.atkop)
	c:RegisterEffect(e4)
	--add setcode
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetValue(0x1073)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(19007857,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c19007857.spcon)
	e6:SetCost(c19007857.spcost)
	e6:SetTarget(c19007857.sptg)
	e6:SetOperation(c19007857.spop)
	c:RegisterEffect(e6)
end
function c19007857.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c19007857.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(aux.TRUE,1-tp,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetFieldGroup(1-tp,aux.TRUE,tp,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c19007857.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c19007857.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsFaceup() and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end
function c19007857.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19007857.cfilter,1,nil,tp)
end
function c19007857.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19007857.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c19007857.dscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,19007856)
end
function c19007857.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRankAbove(4)
end
function c19007857.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19007857.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007857.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c19007857.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19007857,2))
	local g1=Duel.SelectTarget(tp,c19007857.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19007857,3))
	local g2=Duel.SelectTarget(tp,c19007857.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	e:SetLabelObject(g1:GetFirst())
end
function c19007857.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) then
		Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc1:GetAttack())
		tc2:RegisterEffect(e1)
	end
end
function c19007857.spcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c19007857.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c19007857.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c19007857.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c19007857.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007857.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19007857.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c19007857.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c19007857.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c19007857.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
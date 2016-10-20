--Freely Tomorrow: The Starter Chord - Song of Reincarnation and a New Life
function c990810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c990810.actcost)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetCountLimit(1)
	e2:SetCondition(c990810.repcon)
	e2:SetCost(c990810.specost)
	e2:SetTarget(c990810.reptg)
	e2:SetOperation(c990810.repop)
	c:RegisterEffect(e2)
	--property related
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(990810,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c990810.atkcon)
	e3:SetCost(c990810.atkcost)
	e3:SetTarget(c990810.atktg)
	e3:SetOperation(c990810.atkop)
	c:RegisterEffect(e3)
end
function c990810.actfilter(c)
	return c:IsSetCard(0x0dac404) and c:IsFaceup()
end
function c990810.actcost(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.CheckReleaseGroup(tp,c990810.actfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c990810.actfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c990810.repcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFlagEffect(tp,990810)==0
end
function c990810.specost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c990810.repfilter(c)
	return c:GetCode()==990812
end
function c990810.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c990810.repfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c990810.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	local tg=Duel.GetMatchingGroup(c990810.repfilter,tp,LOCATION_DECK,0,nil)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(990810,0))
		tc=Duel.SelectMatchingCard(tp,c990810.repfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	else
		tc=tg:GetFirst()
	end	
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RegisterFlagEffect(tp,990810,RESET_PHASE+PHASE_END,0,1)
	Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c990810.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return c:IsOnField() and c:IsSetCard(0x0dac405)
end
function c990810.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c990810.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c990810.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(300)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end

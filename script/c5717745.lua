--Calc
function c5717745.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5717745.target)
	e1:SetOperation(c5717745.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c5717745.reptg)
	e2:SetValue(c5717745.repval)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c5717745.thcost)
	e3:SetTarget(c5717745.thtg)
	e3:SetOperation(c5717745.thop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5717745,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c5717745.drcon)
	e4:SetTarget(c5717745.drtg)
	e4:SetOperation(c5717745.drop)
	c:RegisterEffect(e4)
	if not c5717745.global_check then
		c5717745.global_check=true
		c5717745[0]=0
		c5717745[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c5717745.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(c5717745.addcount)
		Duel.RegisterEffect(e6,0)
	end
end
function c5717745.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c5717745[tp]>0
end
function c5717745.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c5717745[tp]) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c5717745[tp])
end
function c5717745.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,c5717745[tp],REASON_EFFECT)
end
function c5717745.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c5717745[0]=0
	c5717745[1]=0
end
function c5717745.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and tc:IsSetCard(0x0dac402) then
			local p=tc:GetSummonPlayer()
			c5717745[p]=c5717745[p]+1
		end
		tc=eg:GetNext()
	end
end
function c5717745.fil(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c5717745.cfil(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c5717745.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c5717745.fil(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c5717745.fil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c5717745.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(5717745,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c5717745.fil,tp,LOCATION_MZONE,0,1,1,nil)
	else
		e:SetProperty(0)
	end
end
function c5717745.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local tgg=Duel.GetMatchingGroup(c5717745.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if tgg:GetCount()==0 then return end
	local sg=tgg:Select(tp,1,tgg:GetCount(),nil)
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c5717745.aafil(c)
	return c:IsRace(RACE_MACHINE)
end
function c5717745.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c5717745.aafil(c) and c:IsReason(REASON_BATTLE) and c:GetFlagEffect(5717745)==0
end
function c5717745.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c5717745.repfilter,1,nil,tp) end
	local g=eg:Filter(c5717745.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(5717745,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5717745,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c5717745.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c5717745.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5717745.thfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c5717745.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5717745.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5717745.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5717745.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

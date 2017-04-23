--Vocaloid Ultimate Alternation The False Angel Rin
function c990815.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(990815,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c990815.atkcost)
	e2:SetTarget(c990815.atktg)
	e2:SetOperation(c990815.atkop)
	c:RegisterEffect(e2)
	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c990815.winop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--attach
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c990815.attcon)
	e5:SetTarget(c990815.atttg)
	e5:SetOperation(c990815.attop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(990815,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e6:SetCountLimit(1,990815)
	e6:SetCost(c990815.thcost)
	e6:SetTarget(c990815.thtg)
	e6:SetOperation(c990815.thop)
	c:RegisterEffect(e6)
	--Type Machine
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_ADD_RACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(RACE_MACHINE)
	c:RegisterEffect(e7)
	--Unaffected by Opponent Card Effects
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c990815.unval)
	c:RegisterEffect(e8)
	--release limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_UNRELEASABLE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--avoid damage
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--disable spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCondition(c990815.discon)
	e11:SetTargetRange(1,1)
	c:RegisterEffect(e11)
	--recover LP
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(990815,2))
	e12:SetCategory(CATEGORY_RECOVER)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCountLimit(1,990815)
	e12:SetCost(c990815.recccost)
	e12:SetTarget(c990815.recctg)
	e12:SetOperation(c990815.reccop)
	c:RegisterEffect(e12)
end
function c990815.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c990815.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.PayLPCost(tp,Duel.GetLP(tp)-100)
end
function c990815.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac401) or c:IsSetCard(0x0dac402) or c:IsSetCard(0x0dac403) or c:IsSetCard(0x0dac404) or c:IsSetCard(0x0dac405)
end
function c990815.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c990815.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c990815.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,5,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c990815.atkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c990815.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c990815.atkfilter,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	local atk=0
	while tc do
		local oatk=tc:GetTextAttack()
		if oatk<0 then oatk=0 end
		atk=atk+oatk
		tc=og:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
end
function c990815.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c990815.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	if sg>0 then
		Duel.Overlay(e,Group.FromCards(sg))
	end
end
function c990815.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_THE_FALSE_ANGEL=0x59
	if e:GetHandler():GetOverlayCount()==10 then
		Duel.Win(tp,WIN_REASON_THE_FALSE_ANGEL)
	end
end
function c990815.attcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFlagEffect(tp,990810)==0
end
function c990815.attfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405)
end
function c990815.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c990815.attfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c990815.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c990815.attfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c990815.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c990815.thfilter(c)
	return c:IsSetCard(0x0dac406) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c990815.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c990815.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c990815.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c990815.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c990815.discon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function c990815.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:GetCode()~=990815
end
function c990815.recccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c990815.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c990815.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c990815.recctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c990815.reccop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

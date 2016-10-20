--Secret Art of Golem Summoning
function c66165085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c66165085.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--additional draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c66165085.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c66165085.drawop)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c66165085.mtop)
	c:RegisterEffect(e5)
	--send to grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66165085,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,66165085)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCondition(c66165085.condition)
	e6:SetTarget(c66165085.tgtg)
	e6:SetOperation(c66165085.tgop)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(66165085,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,66165085)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCondition(c66165085.condition)
	e7:SetTarget(c66165085.drtg)
	e7:SetOperation(c66165085.drop)
	c:RegisterEffect(e7)
	--search
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(66165085,3))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1,66165085)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c66165085.condition)
	e8:SetTarget(c66165085.thtg)
	e8:SetOperation(c66165085.thop)
	c:RegisterEffect(e8)
	--recover
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(66165085,4))
	e9:SetCategory(CATEGORY_RECOVER)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	e9:SetCountLimit(1,66165085)
	e9:SetCondition(c66165085.condition)
	e9:SetTarget(c66165085.rectg)
	e9:SetOperation(c66165085.recop)
	c:RegisterEffect(e9)
end
function c66165085.indtg(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165085.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(66165078) then
		e:GetHandler():RegisterFlagEffect(66165085,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	end
end
function c66165085.drawop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(66165085)~=0 and re:GetHandler():IsCode(66165078) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c66165085.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>1000 and Duel.SelectYesNo(tp,aux.Stringid(66165085,0)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c66165085.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(eg:GetFirst():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165085.tgfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function c66165085.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c66165085.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c66165085.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66165085.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c66165085.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66165085.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66165085.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xea010) and c:IsAbleToHand()
end
function c66165085.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66165085.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66165085.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66165085.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66165085.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c66165085.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

-- Nirvana, Realm of Harmony and Balance
function c59821089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c59821089.acttg)
	e1:SetOperation(c59821089.actop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c59821089.valcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c59821089.tg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c59821089.sumlimit)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821089,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,59821089)
	e5:SetCondition(c59821089.condition)
	e5:SetTarget(c59821089.drtg)
	e5:SetOperation(c59821089.drop)
	c:RegisterEffect(e5)
	--lp gain
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821089,0))
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,59821089)
	e6:SetCondition(c59821089.condition)
	e6:SetTarget(c59821089.rectg)
	e6:SetOperation(c59821089.recop)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59821089,2))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,59821089)
	e7:SetCondition(c59821089.condition)
	e7:SetTarget(c59821089.thtg)
	e7:SetOperation(c59821089.thop)
	c:RegisterEffect(e7)
end
function c59821089.desfilter(c)
	return not c:IsSetCard(0xa1a2) and c:IsDestructable()
end
function c59821089.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c59821089.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c59821089.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821089.desfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c59821089.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xa1a2)
end
function c59821089.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c59821089.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049) or c:IsCode(59821085)
end
function c59821089.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa1a2)
end
function c59821089.emmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ)
end
function c59821089.condition(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) and eg:IsExists(c59821089.emmfilter,1,nil)
end
function c59821089.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821089.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c59821089.thfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsAbleToHand()
end
function c59821089.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821089.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821089.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821089.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c59821089.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c59821089.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

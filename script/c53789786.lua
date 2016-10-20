--The Ancestor's Rage
function c53789786.initial_effect(c)
	c:SetUniqueOnField(1,0,53789786)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c53789786.descon)
	e4:SetTarget(c53789786.destg)
	e4:SetOperation(c53789786.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c53789786.descon2)
	e6:SetOperation(c53789786.desop2)
	c:RegisterEffect(e6)
	--shuffle
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(53789786,0))
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c53789786.shufflecon)
	e7:SetTarget(c53789786.shuffletg)
	e7:SetOperation(c53789786.shuffleop)
	c:RegisterEffect(e7)
end
function c53789786.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function c53789786.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53789786.cfilter,1,nil)
end
function c53789786.desfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c53789786.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c53789786.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53789786.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c53789786.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c53789786.actlimit(g:GetFirst()))
end
function c53789786.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c53789786.actlimit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c53789786.destructfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_SPIRIT)
end
function c53789786.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53789786.destructfilter,1,nil,tp)
end
function c53789786.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c53789786.shufflecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>5
end
function c53789786.shuffletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,2,5) end
	Duel.SetTargetPlayer(tp)
end
function c53789786.shuffleop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,5,REASON_EFFECT)
end
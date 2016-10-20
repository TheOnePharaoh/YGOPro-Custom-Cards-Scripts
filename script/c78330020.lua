--AB Assassin
function c78330020.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330020,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(c78330020.target)
	e1:SetOperation(c78330020.operation)
	c:RegisterEffect(e1)
	--deckdes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330020,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c78330020.ddtg)
	e2:SetOperation(c78330020.ddop)
	c:RegisterEffect(e2)
end
function c78330020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c78330020.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c78330020.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
end
function c78330020.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end

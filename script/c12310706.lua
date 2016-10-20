--Seath the Scaleless
--lua script by SGJin
function c12310706.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_NORMAL),1)
	c:EnableReviveLimit()
	--Dual Type! Magic Spellcaster Dragon!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e1)
	--ATK up!
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12310706.val)
	c:RegisterEffect(e2)
	-- You have been Cursed! D: (reduce opponent's life points by half)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310706,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c12310706.damcon)
	e3:SetTarget(c12310706.damtg)
	e3:SetOperation(c12310706.damop)
	c:RegisterEffect(e3)
	-- Drops Humanity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310706,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310706.thcon)
	e4:SetTarget(c12310706.thtg)
	e4:SetOperation(c12310706.thop)
	c:RegisterEffect(e4)
end
function c12310706.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*100 -- 100 ATK for each Spell card
end
function c12310706.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ev>=1500
end
function c12310706.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c12310706.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,Duel.GetLP(p)/2)
end
function c12310706.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310706.filter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() 
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310706.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310706.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310706.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310706.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

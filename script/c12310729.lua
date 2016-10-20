--Crystal Lizard
--lua script by SGJin
function c12310729.initial_effect(c)
	--Hard to Kill 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(2)
	e1:SetValue(c12310729.con)
	c:RegisterEffect(e1)
	--Draw card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310729,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c12310729.drcon)
	e2:SetTarget(c12310729.drtg)
	e2:SetOperation(c12310729.drop)
	c:RegisterEffect(e2)
end
function c12310729.con(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c12310729.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
end
function c12310729.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(e:GetHandler():GetPreviousControler())
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c12310729.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
